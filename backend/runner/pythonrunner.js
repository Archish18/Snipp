const fs = require('fs-extra');
const { spawn } = require('child_process');
const { v4: uuid } = require('uuid');

async function runPythonCode(code, input = "") {
  const filename = `${uuid()}.py`;
  const filepath = `/tmp/${filename}`;

  try {
    // Write code to temp file
    await fs.writeFile(filepath, code);

    return new Promise((resolve) => {
      const process = spawn('python3', [filepath]);

      let stdout = '';
      let stderr = '';

      // Handle stdout
      process.stdout.on('data', (data) => {
        stdout += data.toString();
      });

      // Handle stderr
      process.stderr.on('data', (data) => {
        stderr += data.toString();
      });

      // Write input to stdin
      if (input && input.trim() !== "") {
        process.stdin.write(input);
      }
      process.stdin.end();

      // Timeout handler
      const timeout = setTimeout(() => {
        process.kill('SIGTERM');
        resolve('❌ Error: Code execution timed out after 10 seconds.');
      }, 10000);

      process.on('close', (code) => {
        clearTimeout(timeout);
        fs.unlink(filepath).catch(() => {});

        if (code === 0) {
          resolve(stdout || "✅ Code executed successfully but returned no output.");
        } else {
          resolve(stderr || `❌ Code exited with code ${code}`);
        }
      });
    });
  } catch (err) {
    return `❌ Internal server error: ${err.message}`;
  }
}

module.exports = { runPythonCode };
