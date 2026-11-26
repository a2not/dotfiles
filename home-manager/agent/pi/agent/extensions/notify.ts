/**
 * Desktop notifications for Pi, for terminals tmux otherwise starves.
 *
 * Ghostty's `notify-on-command-finish` never fires inside tmux: tmux swallows
 * the OSC 133 prompt marks that drive it, and it swallows agent notifications
 * (OSC 777) too. So Pi emits OSC 777 itself and wraps it in tmux's DCS
 * passthrough (`set -g allow-passthrough all`, see home-manager/tmux/tmux.conf).
 *
 * Covers a settled run inside tmux only, since outside tmux Ghostty's own
 * notify-on-command-finish already does, and any prompt Pi blocks on.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const TITLE = "Pi";

// tmux clears TMUX from sandboxed processes (nono allow_vars in
// home-manager/agent/nono.nix) but leaves TERM, which tmux sets from
// default-terminal.
const inTmux = Boolean(process.env.TMUX) || (process.env.TERM ?? "").startsWith("tmux");

// OSC 777 is the rxvt/Ghostty notification form; an ESC, BEL, or `;` of our own
// would end the sequence early.
function notify(body: string): void {
	const safe = body
		.replace(/[;\x00-\x1f\x7f]+/g, " ")
		.trim()
		.slice(0, 160);
	// Pi's stdout is the pane tty, so tmux reads this and forwards the payload
	// to the outer terminal once every ESC inside it is doubled.
	const payload = `\x1b]777;notify;${TITLE};${safe}\x07`;
	process.stdout.write(inTmux ? `\x1bPtmux;${payload.replace(/\x1b/g, "\x1b\x1b")}\x1b\\` : payload);
}

export default function terminalNotify(pi: ExtensionAPI) {
	pi.on("agent_settled", (event, ctx) => {
		// Outside tmux Ghostty already notifies, and Escape means the user
		// aborted from the keyboard, so they already know.
		if (!inTmux || ctx.mode !== "tui" || event.aborted) return;
		notify("Ready for input");
	});

	// Extension dialogs and custom tool UIs (ask_user_question, confirmation
	// gates). A prompt the user opened arrives while Pi is idle, and they are
	// already looking at it.
	pi.on("ui_prompt_start", (event, ctx) => {
		if (ctx.mode !== "tui" || ctx.isIdle()) return;
		notify(event.title ? `Waiting: ${event.title}` : "Waiting for your input");
	});
}
