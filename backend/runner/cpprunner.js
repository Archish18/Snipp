const fs = require('fs-extra');
const { exec } = require('child_process');
const { v4: uuid } = require('uuid');

async function runCppCode(code) {
  const filename = `${uuid()}`;
  const filepath = `/tmp/${filename}`;
  const cppFile = `${filepath}.cpp`;
  const outFile = `${filepath}.out`;

  await fs.writeFile(cppFile, code);

  return new Promise((resolve) => {
    exec(`g++ ${cppFile} -o ${outFile} && ${outFile}`, (err, stdout, stderr) => {
      if (err) resolve(stderr);
      else resolve(stdout);
      fs.unlink(cppFile);
      fs.unlink(outFile);
    });
  });
}

module.exports = { runCppCode };
