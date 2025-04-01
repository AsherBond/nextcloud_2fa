/**
 * SPDX-FileCopyrightText: 2018 Nextcloud GmbH and Nextcloud contributors
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

import { shallowMount, createLocalVue } from '@vue/test-utils'
import { createPinia, PiniaVuePlugin, setActivePinia } from 'pinia'
import Nextcloud from '../../../mixins/Nextcloud.js'
import PersonalSettings from '../../../components/PersonalSettings.vue'
import { useMainStore } from '../../../store.js'

const localVue = createLocalVue()

localVue.mixin(Nextcloud)
localVue.use(PiniaVuePlugin)

describe('PersonalSettings', () => {
	let pinia

	beforeEach(() => {
		pinia = createPinia()
		setActivePinia(pinia)
	})

	it('shows text if no devices are configured', () => {
		const settings = shallowMount(PersonalSettings, {
			pinia,
			localVue,
		})

		expect(settings.text()).to.contain('No security keys configured. You are not using WebAuthn as second factor at the moment.')
	})

	it('shows no info text if devices are configured', () => {
		const mainStore = useMainStore()
		mainStore.$patch({
			devices: [{
				id: 'k1',
				name: 'a',
			}],
		})

		const settings = shallowMount(PersonalSettings, {
			pinia,
			localVue,
		})

		expect(settings.text()).to.not.contain('No security keys configured. You are not using WebAuthn as second factor at the moment.')
	})

	it('shows a HTTP warning', () => {
		const settings = shallowMount(PersonalSettings, {
			pinia,
			localVue,
			propsData: {
				httpWarning: true,
			},
		})

		expect(settings.text()).to.contain('You are accessing this site via an')
	})
})
