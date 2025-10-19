use crate::prompt_parts::truncate::TruncateConf;
use serde::Deserialize;
use std::env;

use git2::Repository;

use super::PromptPart;

#[derive(Deserialize, Clone)]
pub struct GitBranchConf {
    pub format: String,
    pub truncate: Option<TruncateConf>,
}

pub struct GitBranch {
    pub format: String,
}

impl PromptPart for GitBranch {
    fn get_output(&mut self) -> String {
        let repo_path = env::current_dir().expect("Failed to get current directory");
        match Repository::open(repo_path) {
            Ok(repo) => match repo.head() {
                Ok(head) => self.format.replace(
                    "{branch_name}",
                    if let Some(branch) = head.shorthand() {
                        branch
                    } else {
                        "(detached HEAD)"
                    },
                ),
                Err(_) => String::new(),
            },
            Err(_) => String::new(),
        }
    }
}
