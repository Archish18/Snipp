const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { runPythonCode } = require('./runner/pythonrunner');
const { runCppCode } = require('./runner/cpprunner');

const app = express();
app.use(cors());
app.use(bodyParser.json());

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

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
