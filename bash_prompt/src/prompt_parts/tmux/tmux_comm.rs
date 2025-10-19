use std::{env, process::Command};

pub struct TmuxCommunication {}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TmuxWin {
    pub id: String,
    pub name: String,
}

impl From<&str> for TmuxWin {
    /// Assumes `value` is one line of the output of tmux list-windows -F '#{window_id} #{window_name}'
    fn from(value: &str) -> Self {
        let mut split = value.trim().splitn(2, " ");
        let id = split.next().unwrap().trim().to_owned();
        let name = split.next().unwrap().trim().to_owned();
        Self { id, name }
    }
}

impl TmuxCommunication {
    /// Check that we are in a tmux session before creating a `TmuxCommunication`.
    pub fn new() -> Option<Self> {
        match env::var("TMUX") {
            Err(_) => None,
            Ok(tmux_var) if tmux_var.is_empty() => None,
            Ok(_) => Some(Self {}),
        }
    }

    pub fn session_name(&self) -> String {
        self.get_tmux_cmd_output(&["display-message", "-p", "#S"])
            .trim()
            .to_owned()
    }

    pub fn windows_in_cur_session(&self) -> Vec<TmuxWin> {
        self.get_tmux_cmd_output(&["list-windows", "-F", "#{window_id} #{window_name}"])
            .trim()
            .lines()
            .map(TmuxWin::from)
            .collect()
    }

    pub fn cur_win(&self) -> TmuxWin {
        TmuxWin::from(
            self.get_tmux_cmd_output(&["display-message", "-p", "#{window_id} #{window_name}"])
                .trim(),
        )
    }

    fn get_tmux_cmd_output(&self, args: &[&str]) -> String {
        let mut cmd = Command::new("tmux");
        let cmd = cmd.args(args);
        String::from_utf8_lossy(
            cmd.output().expect("construction of `TmuxCommunication` should imply we're in a tmux session, but somethign went wrong").stdout.as_slice()
        ).into_owned()
    }
}
