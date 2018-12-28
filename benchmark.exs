FastGlobal.put(:data, "hello")
hello = "hello"


Benchee.run(%{
  "Run loader"    => fn -> Fastfwd.Loader.run() end,
  "Run loader and write"    => fn -> FastGlobal.put(:data, Fastfwd.Loader.run())  end,
  "Write hello to global" => fn -> FastGlobal.put(:data, "hello") end,
  "Read hello from global" => fn -> FastGlobal.get(:data) end,
  "Read hello from variable" => fn -> x = hello end,
})