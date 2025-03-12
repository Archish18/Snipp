const fs = require('fs-extra');
const { exec } = require('child_process');
const { v4: uuid } = require('uuid');

async function runPythonCode(code) {
  const filename = `${uuid()}.py`;
  const filepath = `/tmp/${filename}`;

  try {
    // Save code to a temporary file
    await fs.writeFile(filepath, code);

    return new Promise((resolve) => {
      // Execute code with timeout
      exec(`timeout 10s python3 ${filepath}`, (err, stdout, stderr) => {
        // Clean up temp file after execution
        fs.unlink(filepath).catch(() => {});

        if (err) {
          // If execution exceeded time limit
          if (err.signal === 'SIGTERM') {
            resolve("❌ Error: Code execution timed out after 10 seconds.");
          } else {
            resolve(stderr || err.message);
          }
        } else {
          resolve(stdout || "✅ Code executed successfully but returned no output.");
        }
      });
    });
  } catch (e) {
    return `❌ Internal server error: ${e.message}`;
  }
}

module.exports = { runPythonCode };
