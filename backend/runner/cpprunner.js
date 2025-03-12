const fs = require('fs-extra');
const { exec } = require('child_process');
const { v4: uuid } = require('uuid');

async function runCppCode(code) {
  const filename = `${uuid()}`;
  const cppPath = `/tmp/${filename}.cpp`;
  const outPath = `/tmp/${filename}.out`;

  await fs.writeFile(cppPath, code);

  return new Promise((resolve) => {
    exec(`g++ ${cppPath} -o ${outPath}`, (compileErr, _, compileStderr) => {
      if (compileErr) {
        fs.unlink(cppPath);
        resolve(compileStderr);
        return;
      }

      exec(`timeout 5s ${outPath}`, (runErr, stdout, stderr) => {
        fs.unlink(cppPath);
        fs.unlink(outPath);

        if (runErr) {
          if (runErr.signal === 'SIGTERM') {
            resolve("Error: Code execution timed out.");
          } else {
            resolve(stderr || runErr.message);
          }
        } else {
          resolve(stdout);
        }
      });
    });
  });
}

module.exports = { runCppCode };
