select a.PatientFirstName,a.PatientLastName, a.PatientSSN, count(a.PatientSID) as offenses
from (

select distinct
 p.PatientSID,
 p.PatientSSN,
 p.PatientFirstname,
 p.PatientLastName,
 edis2.PatientArrivalDateTime
from (
select 
	edis.PatientSID,
	patient.PatientSSN,
	patient.PatientFirstName,
	patient.PatientLastName,
	disp.TrackingCodeName,
	disp.TrackingCode,
	disp.DisplayNameAbbreviation,
	disp.EDISTrackingCodeSID,
	edis.PatientArrivalDateTime,
	inpat.AdmitDateTime as InpatAdmit,
	edis.Sta3n

from CDWWork.EDIS.EDISLog as edis
inner join cdwwork.Dim.EDISTrackingCode as disp
	on edis.DispositionEDISTrackingCodeSID = disp.EDISTrackingCodeSID
inner join cdwwork.Inpat.Inpatient as inpat
	on inpat.PatientSID = edis.PatientSID and inpat.Sta3n=edis.Sta3n
inner join cdwwork.SPatient.SPatient as patient
	on patient.PatientSID = edis.PatientSID
inner join LSV.[BISL_Collab].[CANScore_Weekly] as can 
	on can.PatientICN = patient.PatientICN
where edis.Sta3n = '612'
and (datediff(d,edis.PatientArrivalDateTime,getdate())=1  or
 datediff(d,edis.PatientArrivalDateTime,getdate())=2  or datediff(d,edis.PatientArrivalDateTime,getdate())=3 )
and disp.TrackingCode = 'VA' ) as p
inner join CDWWork.EDIS.EDISLog as edis2 on
	edis2.PatientSID = p.PatientSID and edis2.Sta3n = p.Sta3n
where datediff(d,edis2.PatientArrivalDateTime,getdate())<=365 

  ) as a
  group by a.PatientFirstName, a.PatientLastName, a.PatientSSN

  