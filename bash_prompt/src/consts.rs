use once_cell::sync::Lazy;
use std::path::PathBuf;

pub const HOME_DIR: Lazy<PathBuf> = Lazy::new(|| dirs::home_dir().unwrap());

pub const CONF_LOCATION: Lazy<PathBuf> =
    Lazy::new(|| HOME_DIR.join(".config/bash_prompt/config.toml"));
