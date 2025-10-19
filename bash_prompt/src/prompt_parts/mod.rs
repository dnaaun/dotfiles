use crate::conf::PromptPartConf;
use crate::consts::CONF_LOCATION;
use once_cell::sync::Lazy;
use std::fs::File;
use std::io::Read;
use std::path::Path;

use crate::conf::Conf;

use self::current_dir::CurrentDirConf;
use self::git_branch::GitBranchConf;
use self::tmux::TmuxConf;
use self::truncate::TruncateConf;

pub mod current_dir;
pub mod git_branch;
pub mod tmux;
pub mod truncate;

pub trait PromptPart {
    fn get_output(&mut self) -> String;
}

pub type BoxedPromptPart = Box<dyn PromptPart>;

const DEFAULT_CONF: Lazy<Conf> = Lazy::new(|| Conf {
    prompt_parts: [
        PromptPartConf::Tmux(TmuxConf {
            format: " {session_name}".to_string(),
            truncate: None,
        }),
        PromptPartConf::GitBranch(GitBranchConf {
            format: "  {branch_name} ".to_string(),
            truncate: Some(TruncateConf {
                max_len: 30,
                ellipsis_str: "..".to_string(),
                elide_from_start: None,
            }),
        }),
        PromptPartConf::CurrentDir(CurrentDirConf {
            format: "  {current_dir} ".to_string(),
            truncate: None,
            relative_to_git_root: Some(true),
        }),
    ]
    .to_vec(),
});

fn read_config(filename: &Path) -> Result<String, Box<dyn std::error::Error>> {
    let mut file = File::open(filename)?;
    let mut content = String::new();
    file.read_to_string(&mut content)?;

    Ok(content)
}

impl Conf {
    pub fn read_from_config_file() -> Vec<BoxedPromptPart> {
        let config_str = read_config(&CONF_LOCATION);
        let config: Conf = match config_str {
            Ok(config_str) => match toml::from_str::<Conf>(&config_str) {
                Ok(config) => config,
                Err(err) => {
                    eprintln!(
                        "Configuration file at {} is either invalid TOML, or doesn't match the expected schema: {}",
                        CONF_LOCATION.to_str().unwrap(),
                        err
                    );
                    DEFAULT_CONF.clone()
                }
            },
            Err(_) => {
                eprintln!(
                    "Couldn't read the configuration file at: {}",
                    CONF_LOCATION.to_str().unwrap()
                );
                DEFAULT_CONF.clone()
            }
        };

        config.turn_to_prompt_parts()
    }
}
