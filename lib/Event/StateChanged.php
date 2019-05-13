<?php

declare(strict_types=1);

/**
 * Nextcloud - Webauthn 2FA
 *
 * This file is licensed under the Affero General Public License version 3 or
 * later. See the COPYING file.
 *
 * @author Christoph Wurst <christoph@winzerhof-wurst.at>
 * @copyright Christoph Wurst 2018
 */

namespace OCA\TwoFactorWebauthn\Event;

use OCP\IUser;
use Symfony\Component\EventDispatcher\Event;

class StateChanged extends Event {

	/** @var IUser */
	private $user;

	/** @var bool */
	private $enabled;

	public function __construct(IUser $user, bool $enabled) {
		$this->user = $user;
		$this->enabled = $enabled;
	}

	/**
	 * @return IUser
	 */
	public function getUser(): IUser {
		return $this->user;
	}

	/**
	 * @return bool
	 */
	public function isEnabled(): bool {
		return $this->enabled;
	}

}
