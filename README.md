## Team Members: Samantha Fu (sfu12) & Anthony Das (adas22)
# Databases - CS315

### Phase D:
No changes made to plan or data from Phase C.

### Phase E:
Add to Setup Notes:
```
-- This view was created because many of our queries need info to
-- all types of media, so this was used for convenience

CREATE VIEW AllMedia AS
SELECT TV.mediaID, TV.titleJPN, TV.synopsis, TV.rank, TV.startDate, TV.source 
FROM TV
UNION
SELECT * FROM OVA
UNION 
SELECT * FROM Movie;

```