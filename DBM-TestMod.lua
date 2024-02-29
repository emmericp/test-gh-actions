local foo = DBM:NewMod("foo")

foo:RegisterEvents(
	"SPELL_AURA_APPLIED 123"
	"NOT_A_REAL_EVENT"
)

local timer = foo:NewTimer(30, "test")

function foo:SPELL_AURA_APPLIED(args)
	if args:IsSpell(123, 456) then
		foo:start() -- typo
	elseif args.spellId == 789 then
		foo:SendSync("test")
	end
end

foo.SPELL_AURA_APPLIED_DOSE = foo.SPELL_AURA_APPLIED


function foo:OnSync(msg)
	if msg == "bar" then
	end
end
