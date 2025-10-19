use super::PromptPart;
use serde::Deserialize;

#[derive(Deserialize, Clone)]
pub struct TruncateConf {
    pub max_len: usize,
    pub ellipsis_str: String,
    pub elide_from_start: Option<bool>,
}

pub struct Truncate {
    pub inner: Box<dyn PromptPart>,
    pub max_len: usize,
    pub ellipsis_str: String,
    pub elide_from_start: Option<bool>,
}

impl PromptPart for Truncate {
    fn get_output(&mut self) -> String {
        let output = self.inner.get_output();
        truncate(
            &output,
            self.max_len,
            &self.ellipsis_str,
            self.elide_from_start.unwrap_or(false),
        )
    }
}

pub fn truncate(
    output: &str,
    max_len: usize,
    ellipsis_str: &str,
    elide_from_start: bool,
) -> String {
    if output.len() >  max_len {
        if true == elide_from_start {
            let mut final_output = ellipsis_str.to_owned();
            let retain_from_idx = output.len() - max_len;
            final_output.push_str(&output[retain_from_idx..]);
            final_output
        } else {
            let mut output = output.to_owned();
            output.truncate(max_len);
            output.push_str(&ellipsis_str);
            output
        }
    } else {
        output.to_owned()
    }
}
