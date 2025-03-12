async function getAISuggestion(code, language) {
  // Placeholder AI logic - you can integrate OpenAI or other services later
  if (code.includes('print')) {
    return "You are using print. Did you mean to format it better?";
  }

  return "No issues found, code looks fine.";
}

module.exports = { getAISuggestion };