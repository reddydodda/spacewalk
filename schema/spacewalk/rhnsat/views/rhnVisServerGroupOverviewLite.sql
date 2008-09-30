--
-- Copyright (c) 2008 Red Hat, Inc.
--
-- This software is licensed to you under the GNU General Public License,
-- version 2 (GPLv2). There is NO WARRANTY for this software, express or
-- implied, including the implied warranties of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
-- along with this software; if not, see
-- http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
-- 
-- Red Hat trademarks are not licensed under GPLv2. No permission is
-- granted to use or replicate Red Hat trademarks that are incorporated
-- in this software or its documentation. 
--
--
--
--
-- This is much more readable with tabsize as 4.  You've been warned ;)

create or replace view
rhnVisServerGroupOverviewLite as
select	sg.org_id					org_id,
		case when exists (
			select	1
			from	rhnServerGroupOVLiteHelper
			where	server_group_id = sg.id
				and advisory_type = 'Security Advisory'
			)
			then 1
			else 0
			end						security_errata,
		case when exists (
			select	1
			from	rhnServerGroupOVLiteHelper
			where	server_group_id = sg.id
				and advisory_type = 'Bug Fix Advisory'
			)
			then 1
			else 0
			end						bug_errata,
		case when exists (
			select	1
			from	rhnServerGroupOVLiteHelper
			where	server_group_id = sg.id
				and advisory_type = 'Product Enhancement Advisory'
			)
			then 1
			else 0
			end						enhancement_errata,
		sg.id						group_id,
		sg.name						group_name,
		(	select	count(*)
			from	rhnUserManagedServerGroups	umsg
			where	umsg.server_group_id = sg.id
		)							group_admins,
		(	select	count(*)
			from	rhnServerGroupMembers		sgm
			where	sgm.server_group_id = sg.id
		)							server_count,
		0							note_count,
		sysdate						modified,
		max_members					max_members
from	rhnVisibleServerGroup		sg
/

-- $Log$
-- Revision 1.1  2002/11/11 23:37:43  pjones
-- add a Vis varient
--	
