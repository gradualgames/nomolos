.segment "STACK"
.export stack
stack:  .res 256

.segment "BSS"
.export sprite
sprite: .res 256

.export entity_instances
entity_instances: .res 256
.export entity_locals
entity_locals: .res 256
.export entity_counters
entity_counters: .res 32
.export dynamic_palette
dynamic_palette: .res 32