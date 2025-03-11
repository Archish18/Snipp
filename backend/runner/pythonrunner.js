const fs = require('fs-extra');
const { exec } = require('child_process');
const { v4: uuid } = require('uuid');

async function runPythonCode(code) {
  const filename = `${uuid()}.py`;
  const filepath = `/tmp/${filename}`;
  await fs.writeFile(filepath, code);

  return new Promise((resolve) => {
    exec(`python3 ${filepath}`, (err, stdout, stderr) => {
      if (err) resolve(stderr);
      else resolve(stdout);
      fs.unlink(filepath);
    });
  });
}

module.exports = { runPythonCode };
