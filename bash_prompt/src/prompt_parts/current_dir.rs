use git2::Repository;
use serde::Deserialize;
use std::path::PathBuf;

use crate::prompt_parts::PromptPart;

use super::truncate::TruncateConf;

#[derive(Deserialize, Clone)]
pub struct CurrentDirConf {
    pub format: String,
    pub truncate: Option<TruncateConf>,
    pub relative_to_git_root: Option<bool>,
}

#[derive(Clone)]
pub struct CurrentDir {
    pub format: String,
    pub relative_to_git_root: Option<bool>,
}

impl PromptPart for CurrentDir {
    fn get_output(&mut self) -> String {
        let current_dir = std::env::current_dir().unwrap();

        let mut current_dir_str = None;
        if let Some(true) = self.relative_to_git_root {
            if let Ok(repo) = Repository::discover(&current_dir) {
                if let Some(root_dir) = repo.path().parent() {
                    let mut relative = PathBuf::new();
                    relative.push(root_dir.file_name().unwrap().to_str().unwrap());
                    let relative =
                        relative.join(pathdiff::diff_paths(current_dir.clone(), root_dir).unwrap());
                    current_dir_str = Some(relative.as_os_str().to_str().unwrap().to_owned());
                }
            }
        };
        let current_dir_str = current_dir_str.unwrap_or(current_dir.to_str().unwrap().to_owned());
        let output = self.format.replace("{current_dir}", &current_dir_str);
        output
    }
}
