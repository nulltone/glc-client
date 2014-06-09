settings = {}
settings.nsq_http_api = "http://glcwalker.ohl:4151"
settings.nsq_host = "glcwalker.ohl"
settings.nsq_port = 4150
settings.nsq_gamestate_topic = "glc-gamestate"
settings.nsq_daemon_topic = "glc-daemon"

settings.tile_height = 16
settings.tile_width = 16
-- when changing the tiles_per_* variables, try to preserve the aspect
-- ratio with the window width/height
settings.tiles_per_row = 16
settings.tiles_per_column = 12
settings.zone_height = 25
settings.zone_width = 25
settings.assets_dir = "assets"

-- currently only works in the ohl office
settings.attempt_mount = false
settings.asset_vm_dir = "assets/vm"
settings.asset_vm_userhost = "vagrant@assets.ohl"
settings.asset_vm_remotedir = "."
settings.asset_vm_keypath = "keys/insecure_private_key"

function mount_vm_command(keypath, userhost, remotedir, where)
  os = require "os"
  -- first, attempt to unmount directory
  os.execute("sudo umount " .. where)
  -- mount
  local str = 'sshfs -o ssh_command="ssh -i ' ..
    keypath .. '" ' ..
    userhost .. ':' ..
    remotedir .. ' ' ..
    where
  print('attempting to mount asset vm: "' .. str .. '"')
  return os.execute(str)
end
settings.mount_asset_vm_command = mount_vm_command