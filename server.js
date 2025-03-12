const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { runPythonCode } = require('./backend/runner/pythonrunner.js');
const { runCppCode } = require('./backend/runner/cpprunner.js');
const { getAISuggestion } = require('./backend/runner/ai/ai.js'); // NEW import

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Run Python code
app.post('/execute/python', async (req, res) => {
  const { code } = req.body;
  const output = await runPythonCode(code);
  res.json({ output });
});

// Run C++ code
app.post('/execute/cpp', async (req, res) => {
  const { code } = req.body;
  const output = await runCppCode(code);
  res.json({ output });
});

// AI Suggestion Endpoint — NEW
app.post('/ai/suggestion', async (req, res) => {
  const { code } = req.body;
  try {
    const suggestion = await getAISuggestion(code);
    res.json({ suggestion });
  } catch (err) {
    console.error("AI Suggestion Error:", err);
    res.status(500).json({ error: 'Failed to generate AI suggestion.' });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
