PROMPT VIEW URP_USER_REPORTS_VW
create or replace force view urp_user_reports_vw (username,
                                                  parentmenuname,
                                                  parentmenudescription,
                                                  submenuname,
                                                  reportname_connectionname
                                                )
as
  select usr.username,
         substr (rleparentmenu.rolename,
                 instr (rleparentmenu.rolename, chr (35), 1, 2) + 1,
                   instr (rleparentmenu.rolename, chr (35), 1, 3)
                 - instr (rleparentmenu.rolename, chr (35), 1, 2)
                 - 1
                ) parentmenuname,
         substr (rleparentmenu.rolename,
                 instr (rleparentmenu.rolename, chr (35), 1, 3) + 1
                ) parentmenudescription,
         substr (rlesubmenu.rolename, 8) submenuname,
         substr (report.value, 5) reportname_connectionname
    from urp_roles rleparentmenu,
         urp_role_permission rpm,
         urp_permissions pms,
         urp_roles rlesubmenu,
         urp_role_permission rpm_report,
         urp_permissions report,
         urp_users usr
   where rleparentmenu.id = rpm.rle_id
     and pms.id = rpm.pms_id
     and rlesubmenu.id = rpm_report.rle_id
     and rpm_report.pms_id = report.id
     and substr (rleparentmenu.rolename, 1, 8) = 'mainmenu'
     and substr (pms.value, 1, 31) =
                                 'submenu' || chr (35) || 'permission2role' || chr (35)
                                 || 'rptmenu'
     and substr (rlesubmenu.rolename, 1, 7) =
           substr (pms.value,
                   instr (pms.value, chr (35), 1, 2) + 1,
                   instr (pms.value, chr (35), 1, 3) - instr (pms.value, chr (35), 1, 2) - 1
                  )
     and rpm_report.pms_id in (
           select rpm_user_role.pms_id
             from urp_role_permission rpm_user_role, urp_user_role url, urp_users inner_usr
            where rpm_user_role.rle_id = url.rle_id
              and inner_usr.id = url.usr_id
              and inner_usr.id = usr.id);

