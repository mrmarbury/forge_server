name "ftb"
description "Feed the Beast Server"
run_list "recipe[role_forge_server]"
override_attributes({
  "forge_server" => {
      "pack" => {
          "name" => "FTBInfinityLite110",
          "version" => "1.3.3"
      }
  }
})
