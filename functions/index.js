const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const {exec} = require("child_process");
const fs = require("fs");
const app = express();

app.use(cors({origin: true}));
app.use(express.json());

app.post("/run", (req, res) => {
  const {code, language} = req.body;

  const filename = language === "cpp" ? "main.cpp" : "script.py";
  const filePath = `/tmp/${filename}`;

  fs.writeFileSync(filePath, code);

  let command = "";

  if (language === "cpp") {
    command = `g++ ${filePath} -o /tmp/a.out && /tmp/a.out`;
  } else if (language === "python") {
    command = `python3 ${filePath}`;
  } else {
    return res.status(400).json({error: "Unsupported language"});
  }

  exec(command, (err, stdout, stderr) => {
    if (err) {
      return res.json({error: stderr || err.message});
    }
    res.json({output: stdout});
  });
});

exports.api = functions.https.onRequest(app);
