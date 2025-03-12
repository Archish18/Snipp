const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { runPythonCode } = require('./backend/runner/pythonrunner');
const { runCppCode } = require('./backend/runner/cpprunner');
const { getAISuggestion } = require('./backend/runner/ai/ai.js'); // ✅ Add this

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ✅ AI Suggestion Route
app.post('/ai/suggestion', async (req, res) => {
  const { code, language } = req.body;

  try {
    const suggestion = await getAISuggestion(code, language);
    res.json({ suggestion });
  } catch (error) {
    res.status(500).json({ error: 'AI suggestion failed.' });
  }
});

// Code execution routes
app.post('/execute/python', async (req, res) => {
  const { code } = req.body;
  const output = await runPythonCode(code);
  res.json({ output });
});

app.post('/execute/cpp', async (req, res) => {
  const { code } = req.body;
  const output = await runCppCode(code);
  res.json({ output });
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
