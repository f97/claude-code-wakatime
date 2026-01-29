// src/install-hooks.ts
import fs from "fs";
import path from "path";
import os from "os";
var CLAUDE_SETTINGS = path.join(os.homedir(), ".claude", "settings.json");
var HOOK_EVENTS = ["PreToolUse", "PostToolUse", "SessionEnd", "UserPromptSubmit", "PreCompact", "SubagentStop", "Stop"];
function loadSettings() {
  if (!fs.existsSync(CLAUDE_SETTINGS)) {
    return {};
  }
  return JSON.parse(fs.readFileSync(CLAUDE_SETTINGS, "utf-8"));
}
function saveSettings(settings) {
  fs.mkdirSync(path.dirname(CLAUDE_SETTINGS), { recursive: true });
  fs.writeFileSync(CLAUDE_SETTINGS, JSON.stringify(settings, null, 2));
}
function installHooks() {
  const settings = loadSettings();
  settings.hooks = settings.hooks || {};
  const hook = {
    matcher: "*",
    hooks: [
      {
        type: "command",
        command: "claude-code-wakatime"
      }
    ]
  };
  let hookAlreadyExists = true;
  for (const event of HOOK_EVENTS) {
    settings.hooks[event] = settings.hooks[event] || [];
    const existingHook = settings.hooks[event].find((existingHook2) => existingHook2.hooks && Array.isArray(existingHook2.hooks) && existingHook2.hooks.some((hookItem) => hookItem.command === "claude-code-wakatime"));
    if (!existingHook) {
      settings.hooks[event].push(hook);
      hookAlreadyExists = false;
    }
  }
  if (hookAlreadyExists) {
    console.log(`WakaTime hooks already installed in Claude ${CLAUDE_SETTINGS}`);
  } else {
    saveSettings(settings);
    console.log(`WakaTime hooks installed in Claude ${CLAUDE_SETTINGS}`);
  }
}
installHooks();
