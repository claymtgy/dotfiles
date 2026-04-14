#!/usr/bin/env bash
# Apply Bluetooth boot fix + secondary NVMe fstab (requires sudo).
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECONDARY_MOUNT="/mnt/secondary-ssd"
SECONDARY_UUID="5CEA19DEEA19B4EC"

die() { echo "error: $*" >&2; exit 1; }

[[ "$(id -u)" -eq 0 ]] || die "run with: sudo $0"

install_bluetooth_unit() {
	install -d /etc/systemd/system
	install -m 0644 "$REPO_ROOT/systemd/system/bluetooth-unblock.service" \
		/etc/systemd/system/bluetooth-unblock.service
	systemctl daemon-reload
	systemctl enable bluetooth-unblock.service
	systemctl start bluetooth-unblock.service
	echo "Enabled bluetooth-unblock.service"
}

patch_fstab() {
	local fstab=/etc/fstab
	local bak="${fstab}.bak.$(date +%Y%m%d%H%M%S)"
	cp -a "$fstab" "$bak"
	echo "Backed up fstab to $bak"

	# Drop stale /mnt/<uuid> lines (devices no longer present).
	grep -v '08700afb-9462-4693-a65f-6f3bd5009ad3' "$bak" \
		| grep -v '97137f65-af39-4ab5-9814-ef93da18bb4a' \
		> "${fstab}.new" || true

	# Remove duplicate entry if we re-run the script.
	if grep -q "$SECONDARY_UUID" "${fstab}.new"; then
		grep -v "$SECONDARY_UUID" "${fstab}.new" > "${fstab}.tmp" && mv "${fstab}.tmp" "${fstab}.new"
	fi

	{
		cat "${fstab}.new"
		echo "# Secondary internal NVMe (NTFS) — SPCC drive"
		echo "UUID=${SECONDARY_UUID} ${SECONDARY_MOUNT} ntfs3 uid=1000,gid=1000,umask=022,nofail,x-gvfs-show 0 0"
	} > "$fstab"
	rm -f "${fstab}.new"
	echo "Updated $fstab"

	mkdir -p "$SECONDARY_MOUNT"
	chmod 755 "$SECONDARY_MOUNT"

	# Avoid double-mount if udisks already has it under /media (same UUID).
	if cur="$(findmnt -n -o TARGET -S "UUID=$SECONDARY_UUID" 2>/dev/null)" && [[ -n "$cur" ]]; then
		if [[ "$cur" != "$SECONDARY_MOUNT" ]]; then
			echo "Unmounting existing mount at $cur so fstab location can be used..."
			umount "$cur" || die "could not umount $cur (close files and retry)"
		fi
	fi

	systemctl daemon-reload
	mount -a
	echo "Mounted $SECONDARY_MOUNT (ntfs3)"
}

install_bluetooth_unit
patch_fstab
echo "Done."
