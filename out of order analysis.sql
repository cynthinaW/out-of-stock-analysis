select loc.shipment_id, loc.sku, loc.exception, iwq.end_location, to_char(min(loc.authorized_date), 'YYYY-MM-DD HH24:MI:SS') AS "flagged_date",
       to_char(min(iwq.completed_date),'YYYY-MM-DD HH24:MI:SS') AS"replenished_date"
           from   inventory_work_queue iwq
                  JOIN
                    (
                    select * from (
select sseh.shipment_id, sseh.exception,sseh.authorized_date, invs.sku,ef.work_type_id, invs.container_key,invs.location_type_id
                     from sg_sku_exception_history sseh
                     join inventory_summary invs on invs.sku=sseh.sku
                     join exporting_flags ef on sseh.shipment_id=ef.shipment_id
                     where ((EF.WORK_TYPE_ID = 1 or EF.WORK_TYPE_ID = 41) and INVs.LOCATION_TYPE_ID = 3)
                           or ((EF.WORK_TYPE_ID = 26 or EF.WORK_TYPE_ID = 22 or EF.WORK_TYPE_ID = 27
                           or EF.WORK_TYPE_ID = 29 or EF.WORK_TYPE_ID = 31 or EF.WORK_TYPE_ID = 32 or EF.WORK_TYPE_ID = 33) and INVs.LOCATION_TYPE_ID = 1)
                           or ((EF.WORK_TYPE_ID = 24 or EF.WORK_TYPE_ID = 25 or EF.WORK_TYPE_ID = 28 or EF.WORK_TYPE_ID = 41) and INVs.LOCATION_TYPE_ID = 7)
                           order by sseh.authorized_date)tim1
                           where tim1.authorized_date::date>= '2020-11-01'::date
                           and  tim1.authorized_date::date<= '2020-12-31'::date
                            
                           )loc
                             on loc.container_key=iwq.end_location
                             AND loc.authorized_date < iwq.completed_date
                             AND loc.sku=iwq.sku
            where iwq.completed_date is not null
                  and iwq.completed_date>='2020-11-01'::date
                  and loc.exception in('EX-OOS', 'MEX-OOS')
                  group by 1,2,3,4
                  order by 1
                           ;