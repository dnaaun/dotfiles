use std::io;
use std::io::Write;

use conf::Conf;

mod conf;
pub mod consts;
mod prompt_parts;

fn main() {
    let mut prompt_parts = Conf::read_from_config_file();
    let mut prompt = String::new();
    for prompt_part_str in prompt_parts.iter_mut().map(|pp| pp.get_output()) {
        prompt.push_str(&prompt_part_str)
    }

    let stdout = io::stdout();
    let mut handle = stdout.lock();
    handle.write_all(prompt.as_bytes()).unwrap();
}
