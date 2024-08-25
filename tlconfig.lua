return {
   source_dir = ".",
   build_dir = "out",
   global_env_def = "hilbish",
   include = {
      "config/*",
      "utils/*",
      "plugins/*",
   },
   include_dir = {
      ".",
      "config",
      "utils",
      "plugins",
      ".libs",
   }
}
