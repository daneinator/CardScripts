--ＣＮｏ.１０６ 溶岩掌ジャイアント・ハンド・レッド (Anime)
--Number C106: Giant Red Hand (Anime)
--Fixed by Larry126
Duel.LoadScript("rankup_functions.lua")
Duel.LoadCardScript("c55888045.lua")
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--Rank Up Check
	aux.EnableCheckRankUp(c,nil,s.rankupregop,63746411)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e1)
	--no effect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.damval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	--Double Snare
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(3682106)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCondition(s.efcon)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5,false,REGISTER_FLAG_DETACH_XMAT)
	local e6=e5:Clone()
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
end
s.listed_series={0x48}
s.xyz_number=106
s.listed_names={63746411}
function s.rankupregop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(FLAG_RANKUP+id,RESET_EVENT+RESETS_STANDARD_DISABLE,0,1)
end
function s.efcon(e)
	return e:GetHandler():GetFlagEffect(FLAG_RANKUP+id)>0
end
function s.eftg(e,c)
	return c==e:GetHandler()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function s.damval(e,re,val,r,rp,rc)
	if e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and r&REASON_EFFECT==REASON_EFFECT then return 0
	else return val end
end
