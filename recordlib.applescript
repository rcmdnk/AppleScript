on getKeyValue(rec, k)
	run script "
on getValue(r)
r's |" & k & "|
end
me"
	result's getValue(rec)
end getKeyValue

on setKeyValue(rec, k, val)
	run script "
 on setValue(r, v)
   try
     set r's |" & k & "| to v
     r
   on error number -10006
     r & {|" & k & "|:v}
   end try
 end
 me"
	result's setValue(rec, val)
end setKeyValue

on run
	-- test
	set rec to {a:1, b:2, c:3}
	log getKeyValue(rec, "a")
	
	set rec to setKeyValue(rec, "d", 4)
	log rec
end run
