const fs = require('fs-extra');
const { exec } = require('child_process');
const { v4: uuid } = require('uuid');

async function runPythonCode(code) {
  const filename = `${uuid()}.py`;
  const filepath = `/tmp/${filename}`;
  await fs.writeFile(filepath, code);

  return new Promise((resolve, reject) => {
    exec(`timeout 5s python3 ${filepath}`, (err, stdout, stderr) => {
      fs.unlink(filepath); // Clean up

      if (err) {
        if (err.signal === 'SIGTERM') {
          resolve("Error: Code execution timed out.");
        } else {
          resolve(stderr || err.message);
        }
      } else {
        resolve(stdout);
      }
    });
  });
}

module.exports = { runPythonCode };
