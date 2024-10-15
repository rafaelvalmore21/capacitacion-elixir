### Semana 4 - Procesos, Concurrencia y Paralelismo

```
sync_fn = fn x -> Process.sleep(3000) "#{x} returned" end

sync_fn.(4)
```