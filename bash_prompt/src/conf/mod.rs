use serde::Deserialize;

use crate::prompt_parts::{
    current_dir::{CurrentDir, CurrentDirConf},
    git_branch::{GitBranch, GitBranchConf},
    tmux::{Tmux, TmuxConf},
    truncate::{Truncate, TruncateConf},
    PromptPart,
};

#[derive(Deserialize, Clone)]
#[serde(tag = "type")]
pub enum PromptPartConf {
    Tmux(TmuxConf),
    GitBranch(GitBranchConf),
    CurrentDir(CurrentDirConf),
}

#[derive(Deserialize, Clone)]
pub struct Conf {
    pub prompt_parts: Vec<PromptPartConf>,
}

impl Conf {
    pub fn turn_to_prompt_parts(self) -> Vec<Box<dyn PromptPart>> {
        self.prompt_parts
            .into_iter()
            .map(|conf| match conf {
                PromptPartConf::Tmux(TmuxConf { format, truncate }) => {
                    (Box::new(Tmux { format }) as Box<dyn PromptPart>, truncate)
                }
                PromptPartConf::GitBranch(GitBranchConf { format, truncate }) => (
                    Box::new(GitBranch { format }) as Box<dyn PromptPart>,
                    truncate,
                ),
                PromptPartConf::CurrentDir(CurrentDirConf {
                    format,
                    truncate,
                    relative_to_git_root,
                }) => (
                    Box::new(CurrentDir {
                        format,
                        relative_to_git_root,
                    }) as Box<dyn PromptPart>,
                    truncate,
                ),
            })
            .map(|(prompt_part, truncate_conf)| match truncate_conf {
                Some(TruncateConf {
                    max_len,
                    ellipsis_str,
                    elide_from_start,
                }) => Box::new(Truncate {
                    inner: prompt_part,
                    max_len,
                    ellipsis_str,
                    elide_from_start,
                }) as Box<dyn PromptPart>,
                None => prompt_part,
            })
            .collect::<Vec<_>>()
    }
}
