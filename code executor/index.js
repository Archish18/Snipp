const express = require('express');
const cors = require('cors');
const fs = require('fs');
const { exec } = require('child_process');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/run', (req, res) => {
  const { code, language } = req.body;

  const filename = language === 'cpp' ? 'main.cpp' : 'script.py';
  const filepath = `/tmp/${filename}`;
  fs.writeFileSync(filepath, code);

  let command = '';
  if (language === 'cpp') {
    command = `g++ ${filepath} -o /tmp/a.out && /tmp/a.out`;
  } else if (language === 'python') {
    command = `python3 ${filepath}`;
  } else {
    return res.status(400).json({ error: 'Unsupported language' });
  }

  exec(command, (err, stdout, stderr) => {
    if (err) {
      return res.json({ error: stderr || err.message });
    }
    res.json({ output: stdout });
  });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
