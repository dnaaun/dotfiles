mod tmux_comm;

use itertools::Itertools;
use serde::Deserialize;

use crate::prompt_parts::PromptPart;

use self::tmux_comm::TmuxCommunication;

use super::truncate::TruncateConf;

#[derive(Deserialize, Clone)]
pub struct TmuxConf {
    pub format: String,
    pub truncate: Option<TruncateConf>,
}

#[derive(Clone)]
pub struct Tmux {
    pub format: String,
}

impl PromptPart for Tmux {
    fn get_output(&mut self) -> String {
        let empty_string = String::new();
        let tmux_comm = match TmuxCommunication::new() {
            Some(tc) => tc,
            None => return empty_string,
        };

        // TODO (David): Collect variable names here.

        let tmux_wins = tmux_comm.windows_in_cur_session();
        let cur_win = tmux_comm.cur_win();
        let windows_status = if tmux_wins.len() <= 1 {
            empty_string.clone()
        } else {
            tmux_wins
                .into_iter()
                .map(|win| {
                    if win == cur_win {
                        "[name]".replace("name", &win.name)
                    } else {
                        // win.name
                        "".to_string()
                    }
                })
                .join(" ")
        };
        let windows_status = if windows_status.len() > 0 {
            "(status )".replace("status", &windows_status)
        } else {
            windows_status
        };
        self.format
            .replace("{session_name}", &tmux_comm.session_name())
            .replace("{windows_status}", &windows_status)
    }
}
