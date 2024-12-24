use interpreter::{function, generate, methods, module, pkg_name};

module! {
  Index,
  pkg_name! { "Hello World package" }
  methods! {
    function!("hello_world", r#"Prints hello world

# Format:
```
hello_world
```
    "#, |_, _, _, _| {
      println!("Hello World");
    })
  }
}

generate!(Index);