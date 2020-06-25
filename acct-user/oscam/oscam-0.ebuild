# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Oscam program user"
ACCT_USER_ID=991
ACCT_USER_GROUPS=( ${PN} uucp )
acct-user_add_deps
KEYWORDS="~amd64 ~x86"

ACCT_USER_HOME=/etc/oscam
ACCT_USER_HOME_PERMS=0750
