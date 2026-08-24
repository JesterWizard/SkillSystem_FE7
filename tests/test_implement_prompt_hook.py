"""beforeSubmitPrompt + preToolUse: structure implement prompts, skip repo search."""
import json
import tempfile
import unittest
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".cursor" / "hooks"))
import implement_prompt as hook  # noqa: E402


class ImplementPromptHookTests(unittest.TestCase):
    def test_submit_without_implement_is_a_no_op(self):
        out = hook.handle(
            {"prompt": "fix the ROM build", "hook_event_name": "beforeSubmitPrompt"}
        )
        self.assertEqual(out.get("continue"), True)
        self.assertNotIn("additional_context", out)

    def test_submit_implement_nullify_injects_file_pack(self):
        out = hook.handle(
            {
                "prompt": "please implement Nullify",
                "hook_event_name": "beforeSubmitPrompt",
            }
        )
        self.assertEqual(out.get("continue"), True)
        brief = out.get("additional_context", "")
        self.assertIn("NullifyID", brief)
        self.assertIn("Nullify.event", brief)
        self.assertIn("Do not search", brief)

    def test_pretool_denies_grep_when_implementing_a_named_skill(self):
        out = hook.handle(
            {
                "hook_event_name": "preToolUse",
                "tool_name": "Grep",
                "tool_input": {"pattern": "Nullify"},
                "prompt": "implement Nullify",
            }
        )
        self.assertEqual(out.get("permission"), "deny")
        self.assertIn("NullifyID", out.get("agent_message", ""))

    def test_pretool_allows_grep_when_prompt_has_no_implement(self):
        out = hook.handle(
            {
                "hook_event_name": "preToolUse",
                "tool_name": "Grep",
                "tool_input": {"pattern": "Nullify"},
                "prompt": "where is Nullify wired",
            }
        )
        self.assertEqual(out.get("permission"), "allow")

    def test_pretool_allows_read(self):
        out = hook.handle(
            {
                "hook_event_name": "preToolUse",
                "tool_name": "Read",
                "tool_input": {"path": "foo.s"},
                "prompt": "implement Nullify",
            }
        )
        self.assertEqual(out.get("permission"), "allow")

    def test_last_user_query_reads_transcript(self):
        with tempfile.NamedTemporaryFile(
            "w", encoding="utf-8", suffix=".jsonl", delete=False
        ) as fh:
            fh.write(
                json.dumps(
                    {
                        "role": "user",
                        "message": {
                            "content": [
                                {
                                    "type": "text",
                                    "text": "<user_query>\nimplement Nullify\n</user_query>",
                                }
                            ]
                        },
                    }
                )
                + "\n"
            )
            path = fh.name
        try:
            q = hook.last_user_query({"transcript_path": path})
        finally:
            Path(path).unlink(missing_ok=True)
        self.assertEqual(q, "implement Nullify")


if __name__ == "__main__":
    unittest.main()
