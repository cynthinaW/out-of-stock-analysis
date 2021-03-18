# out-of-stock-analysis


We are defining out of stocks as a shipment being in an exportable work type, but no physical inventory being in location for one or all of the SKUs in that shipment.  For example, if shipment 1234567 needs skus 24567-00 and 26789-00, and 26789-00 has no units in location, then when that shipment is exported, and the picker tries to pick it, they will need to call someone to confirm an OOS, and then ITC will need to replenish the location.
Some OOS analysis we need (timeframe - Nov-Dec 2020):
Is there a way to see how long it took for ITC to Replenish a location after OOS was flagged
-# of OOS/flagged shipments per day - how many shipments were affected by OOS (like 1% or whatever)
