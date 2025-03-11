const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Code Execution Route
app.post('/execute', async (req, res) => {
  const { code, language } = req.body;

  if (!code || !language) {
    return res.status(400).json({ error: 'Code and language are required' });
  }

  const id = uuidv4();
  const filename = language === 'python' ? `${id}.py` : `${id}.cpp`;
  const filepath = path.join(__dirname, filename);

  fs.writeFileSync(filepath, code);

  let command = '';

  if (language === 'python') {
    command = `python3 ${filepath}`;
  } else if (language === 'cpp') {
    const output = `${id}.out`;
    command = `g++ ${filepath} -o ${output} && ./${output}`;
  } else {
    return res.status(400).json({ error: 'Unsupported language' });
  }

  exec(command, (error, stdout, stderr) => {
    fs.unlinkSync(filepath); // Clean up
    if (language === 'cpp') {
      const outputFile = `${id}.out`;
      if (fs.existsSync(outputFile)) fs.unlinkSync(outputFile);
    }

    if (error) {
      return res.status(200).json({ output: stderr });
    }

    res.status(200).json({ output: stdout });
  });
});

// Placeholder for AI error analysis (you can integrate later)
app.post('/ai-analyze', (req, res) => {
  const { code, language } = req.body;
  // In future: Call OpenAI or CodeT5 here
  res.json({ suggestion: "This is a placeholder for AI error fixing." });
});

app.get('/', (req, res) => {
  res.send('Code Editor Backend is Live 🚀');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
