-- ══════════════════════════════════════════════
-- Rust Snippets (LuaSnip)
-- ══════════════════════════════════════════════

local ls  = require("luasnip")
local s   = ls.snippet
local sn  = ls.snippet_node
local t   = ls.text_node
local i   = ls.insert_node
local f   = ls.function_node
local c   = ls.choice_node
local d   = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("rust", {
  -- fn main
  s("main", fmt([[
fn main() {{
    {}
}}
  ]], { i(1, "todo!()") })),

  -- fn
  s("fn", fmt([[
fn {}({}) {} {{
    {}
}}
  ]], { i(1, "name"), i(2), c(3, { t(""), sn(nil, { t("-> "), i(1, "()") }) }), i(4, "todo!()") })),

  -- pub fn
  s("pfn", fmt([[
pub fn {}({}) {} {{
    {}
}}
  ]], { i(1, "name"), i(2), c(3, { t(""), sn(nil, { t("-> "), i(1, "()") }) }), i(4, "todo!()") })),

  -- struct
  s("st", fmt([[
#[derive({})]
struct {} {{
    {},
}}
  ]], { i(1, "Debug"), i(2, "Name"), i(3) })),

  -- enum
  s("en", fmt([[
#[derive({})]
enum {} {{
    {},
}}
  ]], { i(1, "Debug"), i(2, "Name"), i(3) })),

  -- impl
  s("impl", fmt([[
impl {} {{
    {}
}}
  ]], { i(1, "Type"), i(2) })),

  -- impl trait
  s("implfor", fmt([[
impl {} for {} {{
    {}
}}
  ]], { i(1, "Trait"), i(2, "Type"), i(3) })),

  -- match
  s("mat", fmt([[
match {} {{
    {} => {},
    _ => {},
}}
  ]], { i(1, "expr"), i(2, "pattern"), i(3, "{}"), i(4, "{}") })),

  -- if let
  s("ifl", fmt([[
if let {} = {} {{
    {}
}}
  ]], { i(1, "Some(val)"), i(2, "expr"), i(3) })),

  -- while let
  s("whl", fmt([[
while let {} = {} {{
    {}
}}
  ]], { i(1, "Some(val)"), i(2, "expr"), i(3) })),

  -- Result return
  s("res", fmt([[Result<{}, {}>]], { i(1, "()"), i(2, "Box<dyn std::error::Error>") })),

  -- Option
  s("opt", fmt([[Option<{}>]], { i(1, "T") })),

  -- vec![]
  s("vv", fmt("vec![{}]", { i(1) })),

  -- HashMap
  s("hm", fmt([[
let mut {} = std::collections::HashMap::new();
  ]], { i(1, "map") })),

  -- println with debug
  s("pd", fmt([[println!("{}: {{:?}}", {});]], { i(1, "label"), i(2, "val") })),

  -- println
  s("pp", fmt([[println!("{}", {});]], { i(1), i(2) })),

  -- dbg!
  s("db", fmt([[dbg!({});]], { i(1) })),

  -- eprintln
  s("ep", fmt([[eprintln!("{}", {});]], { i(1), i(2) })),

  -- todo!
  s("td", t("todo!()")),

  -- unimplemented!
  s("un", t("unimplemented!()")),

  -- unreachable!
  s("ur", t("unreachable!()")),

  -- test module
  s("tests", fmt([[
#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn {} () {{
        {}
    }}
}}
  ]], { i(1, "test_name"), i(2) })),

  -- single test
  s("tst", fmt([[
#[test]
fn {}() {{
    {}
}}
  ]], { i(1, "test_name"), i(2) })),

  -- async test
  s("atst", fmt([[
#[tokio::test]
async fn {}() {{
    {}
}}
  ]], { i(1, "test_name"), i(2) })),

  -- derive macro
  s("der", fmt("#[derive({})]", { i(1, "Debug, Clone") })),

  -- allow lint
  s("allow", fmt("#[allow({})]", { i(1, "dead_code") })),

  -- async fn
  s("afn", fmt([[
async fn {}({}) {} {{
    {}
}}
  ]], { i(1, "name"), i(2), c(3, { t(""), sn(nil, { t("-> "), i(1, "()") }) }), i(4) })),

  -- Box<dyn Error>
  s("bde", t("Box<dyn std::error::Error>")),

  -- anyhow result
  s("anyr", t("anyhow::Result<()>")),

  -- use statement
  s("use", fmt([[use {};]], { i(1) })),

  -- mod
  s("mod", fmt([[
mod {} {{
    {}
}}
  ]], { i(1, "name"), i(2) })),

  -- pub mod
  s("pmod", fmt([[pub mod {};]], { i(1, "name") })),

  -- type alias
  s("type", fmt([[type {} = {};]], { i(1, "Alias"), i(2, "Type") })),

  -- const
  s("con", fmt([[const {}: {} = {};]], { i(1, "NAME"), i(2, "Type"), i(3, "value") })),

  -- static
  s("sta", fmt([[static {}: {} = {};]], { i(1, "NAME"), i(2, "Type"), i(3, "value") })),

  -- cloned iterator chain
  s("iter", fmt([[
{}.iter()
    .{}
    .collect::<Vec<_>>()
  ]], { i(1, "collection"), i(2, "map(|x| x)") })),

  -- ? operator with context (anyhow)
  s("ctx", fmt([[.with_context(|| "{}")?]], { i(1, "context message") })),
})
