/*If I am creating a function, the script block will be executed before this script is called*/

if not exists (select * from UpdateLog where ScriptID = '@ScriptID')
begin
	@ScriptBlock
    @InsertUpdateLog
    select 1 [Inserted];
end
else 
begin 
    select 0 [Inserted];
end