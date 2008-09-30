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

-- this seems like maybe it should have action_id as well?
-- maybe optional?

create or replace procedure
set_ks_session_history_message (
	kickstart_session_id_in in number,
	state_label_in in varchar2,
	message_in in varchar2
) is
	cursor states is
		select	id
		from	rhnKickstartSessionState
		where	label = state_label_in;
	cursor history_items(state_id_in in number) is
		select	id
		from	rhnKickstartSessionHistory
		where	kickstart_session_id = kickstart_session_id_in
			and state_id = state_id_in
		order by time desc;
begin
	for state in states loop
		for item in history_items(state.id) loop
			update rhnKickstartSessionHistory
				set message = message_in
				where id = item.id;
			return;
		end loop;
		insert into rhnKickstartSessionHistory (
				id, kickstart_session_id, state_id, message
			) values (
				rhn_ks_sessionhist_id_seq.nextval,
				kickstart_session_id_in,
				state.id,
				message_in
			);
		return;
	end loop;
end;
/
show errors

--
-- $Log$
-- Revision 1.1  2003/12/18 16:30:22  pjones
-- bugzilla: 111909 -- procedure to update error messages for kickstarts
--
