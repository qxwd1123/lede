module("luci.controller.frpc", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/frpc") then
		return
	end

	entry({"admin", "services", "frpc"}, cbi("frpc/frpc"), _("Frpc Setting"), 100).dependent = true
	entry({"admin", "services", "frpc", "config"}, cbi("frpc/config")).leaf = true
	entry({"admin", "services", "frpc", "status"}, call("status")).leaf = true
end

function status()
	local e={}
	e.running=luci.sys.call("pidof frpc > /dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
