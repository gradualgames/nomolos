.include "ram.inc"

.segment "STACK"
stack:  .res 256

.segment "BSS"
sprite: .res 256

entity_instances: .res 256
entity_locals: .res 256
entity_counters: .res 32
dynamic_palette: .res 32