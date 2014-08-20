default["mailutils"]["mailx-package"] = \
  case node["platform_family"]
  when "debian"
    "mailutils"
  when "rhel"
    "mailx"
  end
