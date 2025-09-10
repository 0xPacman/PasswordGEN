<template>
  <div class="max-w-xl mx-auto">
    <div class="text-center mb-6">
      <h1 class="text-3xl md:text-4xl font-bold tracking-tight text-white">Password<span class="text-primary-500">GEN</span></h1>
      <p class="text-gray-400 text-sm">A sleek command palette to craft strong passwords.</p>
    </div>

  <!-- Command Palette -->
    <div class="cmd overflow-hidden">
      <!-- Header / Input like palette search -->
      <div class="cmd-header flex items-center gap-3">
        <svg class="w-5 h-5 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35M10 18a8 8 0 100-16 8 8 0 000 16z"/></svg>
        <input class="cmd-input font-mono" :value="generatedPassword" readonly :placeholder="generatedPassword || 'Generate a secure password'" />
        <button @click="copyToClipboard" :disabled="!generatedPassword" class="ml-auto pill flex items-center gap-1" :class="!generatedPassword && 'opacity-50 cursor-not-allowed'">
          <svg v-if="!copied" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
          <svg v-else class="w-4 h-4 text-green-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
          <span class="hidden sm:inline">Copy</span>
        </button>
      </div>

      <!-- Options (compact & collapsible) -->
      <button class="cmd-item w-full" @click="optionsOpen = !optionsOpen" :aria-expanded="optionsOpen">
        <div class="cmd-icon">⚙</div>
        <div class="flex-1 text-left">
          <div class="text-sm text-gray-100">Options</div>
          <div class="text-xs text-gray-400 truncate">
            <span class="mr-2">A: {{ includeUppercase ? 'on' : 'off' }}</span>
            <span class="mr-2">a: {{ includeLowercase ? 'on' : 'off' }}</span>
            <span class="mr-2">123: {{ includeNumbers ? 'on' : 'off' }}</span>
            <span class="mr-2">#: {{ includeSymbols ? 'on' : 'off' }}</span>
            <span>Len: {{ passwordLength }}</span>
          </div>
        </div>
        <span class="text-gray-400">{{ optionsOpen ? '▾' : '▸' }}</span>
      </button>
      <transition name="fade-slide">
        <div v-if="optionsOpen">
          <div class="px-4 pb-2 flex flex-wrap gap-2">
            <button class="chip" :data-active="includeUppercase" :aria-pressed="includeUppercase" @click.stop="includeUppercase = !includeUppercase">A</button>
            <button class="chip" :data-active="includeLowercase" :aria-pressed="includeLowercase" @click.stop="includeLowercase = !includeLowercase">a</button>
            <button class="chip" :data-active="includeNumbers" :aria-pressed="includeNumbers" @click.stop="includeNumbers = !includeNumbers">123</button>
            <button class="chip" :data-active="includeSymbols" :aria-pressed="includeSymbols" @click.stop="includeSymbols = !includeSymbols">#</button>
          </div>
          <div class="px-4 pb-3">
            <div class="flex items-center justify-between text-xs text-gray-400">
              <span>Length</span>
              <span class="pill">{{ passwordLength }}</span>
            </div>
            <input v-model="passwordLength" type="range" min="8" max="128" class="input-range mt-2" />
          </div>
        </div>
      </transition>

      <div class="cmd-divider"></div>

      <!-- Actions -->
      <div class="cmd-section-title">Actions</div>
      <div class="cmd-item" :aria-selected="true">
        <div class="cmd-icon text-primary-400">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
        </div>
        <button class="text-sm text-gray-100" @click="generatePassword" :disabled="!hasValidOptions">Generate secure password</button>
        <div class="ml-auto flex items-center gap-1 text-gray-400">
          <span class="pill hidden sm:inline">R</span>
        </div>
      </div>
      <div class="px-4 pb-3 text-[11px] text-gray-500">
        Shortcuts: R regenerate • C copy • H history
      </div>

      <!-- Strength -->
      <div v-if="generatedPassword" class="cmd-section-title">Strength</div>
      <div v-if="generatedPassword" class="cmd-item">
        <div class="cmd-icon">🔒</div>
        <div class="flex-1">
          <div class="flex items-center justify-between text-xs text-gray-400">
            <span>Password Strength</span>
            <span :class="strengthColor" class="font-medium">{{ passwordStrength }}</span>
          </div>
          <div class="mt-2 flex gap-2">
            <div v-for="n in 4" :key="n" class="flex-1 h-2 rounded-full overflow-hidden bg-dark-700 relative">
              <div class="absolute inset-0 transition-all duration-500" :class="segmentFillClass(n)"></div>
            </div>
          </div>
          <div class="mt-2 text-[11px] text-gray-400 flex flex-wrap gap-3">
            <span><span class="text-gray-500">Entropy:</span> <span class="text-gray-300 font-mono">{{ entropyBits.toFixed(1) }} bits</span></span>
            <span><span class="text-gray-500">Est. crack:</span> <span class="text-gray-300">{{ crackTime }}</span></span>
            <button class="pill" @click="showInfo=!showInfo">{{ showInfo? 'Hide':'Why?' }}</button>
          </div>
          <transition name="fade-slide">
            <div v-if="showInfo" class="mt-2 text-[11px] leading-relaxed text-gray-300">
              Entropy estimates randomness. Higher bits exponentially increase resistance to brute force.
            </div>
          </transition>
        </div>
      </div>

      <!-- History -->
      <div v-if="history.length" class="cmd-section-title">History</div>
      <div v-if="history.length" class="px-4 pb-4">
        <div class="flex gap-2 overflow-x-auto pb-1 scrollbar-thin">
          <div v-for="item in history" :key="item.id" class="pill whitespace-nowrap flex items-center gap-2">
            <code class="font-mono" :title="item.value">{{ item.revealed ? item.value : mask(item.value) }}</code>
            <button class="text-primary-500 hover:text-primary-400" @click="reUse(item.value)" title="Reuse">↺</button>
            <button class="text-gray-400 hover:text-green-400" @click="reveal(item)" title="Toggle mask">👁</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="text-center mt-6 text-gray-500 text-xs space-y-1">
      <p>All passwords are generated locally in your browser.</p>
      <p>
        Made by
        <a href="https://0xpacman.com" target="_blank" rel="noopener noreferrer" class="text-primary-500 hover:text-primary-400">0xPacman</a>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

// Reactive state
const generatedPassword = ref('')
const passwordLength = ref(16)
const includeUppercase = ref(true)
const includeLowercase = ref(true)
const includeNumbers = ref(true)
const includeSymbols = ref(true)
const copied = ref(false)
const history = ref<{id:number; value:string; revealed?:boolean}[]>([])
// history displayed in bottom section only
const historyOpen = ref(false)
const maxHistory = 5
const entropyBits = computed(() => {
  if (!generatedPassword.value) return 0
  const size = characterSet.value.length
  if (!size) return 0
  return generatedPassword.value.length * Math.log2(size)
})
const crackTime = computed(() => {
  // assume 1e12 guesses/sec modern attacker
  const guessesPerSec = 1e12
  const seconds = Math.pow(2, entropyBits.value) / guessesPerSec
  if (seconds < 60) return seconds.toFixed(2)+ 's'
  const minutes = seconds/60
  if (minutes < 60) return minutes.toFixed(1)+'m'
  const hours = minutes/60
  if (hours < 24) return hours.toFixed(1)+'h'
  const days = hours/24
  if (days < 365) return days.toFixed(1)+'d'
  const years = days/365
  if (years < 1000) return years.toFixed(1)+'y'
  return (years/1000).toFixed(2)+'k years'
})
const showInfo = ref(false)
const optionsOpen = ref(true)
// checklist removed in palette UI

// History helpers
const pushHistory = (pwd:string) => {
  if (!pwd) return
  history.value.unshift({ id: Date.now()+Math.random(), value: pwd })
  if (history.value.length > maxHistory) history.value.pop()
}
const mask = (pwd:string) => pwd.slice(0,4) + '••••' + pwd.slice(-2)
const reveal = (item:{revealed?:boolean}) => { item.revealed = !item.revealed }
const reUse = (pwd:string) => { generatedPassword.value = pwd }

// Character sets
const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz'
const numberChars = '0123456789'
const symbolChars = '!@#$%^&*()_+-=[]{}|;:,.<>?'

// Computed properties
const hasValidOptions = computed(() => {
  return includeUppercase.value || includeLowercase.value || includeNumbers.value || includeSymbols.value
})

const characterSet = computed(() => {
  let chars = ''
  if (includeUppercase.value) chars += uppercaseChars
  if (includeLowercase.value) chars += lowercaseChars
  if (includeNumbers.value) chars += numberChars
  if (includeSymbols.value) chars += symbolChars
  return chars
})

const passwordStrength = computed(() => {
  if (!generatedPassword.value) return 'None'
  
  const length = generatedPassword.value.length
  const hasUpper = /[A-Z]/.test(generatedPassword.value)
  const hasLower = /[a-z]/.test(generatedPassword.value)
  const hasNumber = /[0-9]/.test(generatedPassword.value)
  const hasSymbol = /[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(generatedPassword.value)
  
  let score = 0
  if (length >= 8) score += 1
  if (length >= 12) score += 1
  if (length >= 16) score += 1
  if (hasUpper) score += 1
  if (hasLower) score += 1
  if (hasNumber) score += 1
  if (hasSymbol) score += 1
  
  if (score <= 3) return 'Weak'
  if (score <= 5) return 'Medium'
  if (score <= 6) return 'Strong'
  return 'Very Strong'
})

const strengthColor = computed(() => {
  switch (passwordStrength.value) {
    case 'Weak': return 'text-red-500'
    case 'Medium': return 'text-yellow-500'
    case 'Strong': return 'text-blue-500'
    case 'Very Strong': return 'text-green-500'
    default: return 'text-gray-500'
  }
})

const strengthPercentage = computed(() => {
  switch (passwordStrength.value) {
    case 'Weak': return 25
    case 'Medium': return 50
    case 'Strong': return 75
    case 'Very Strong': return 100
    default: return 0
  }
})

// Password validation function (similar to the shell script)
const isPasswordValid = (password: string): boolean => {
  if (password.length < 8) return false
  
  const hasUpper = includeUppercase.value ? /[A-Z]/.test(password) : true
  const hasLower = includeLowercase.value ? /[a-z]/.test(password) : true
  const hasNumber = includeNumbers.value ? /[0-9]/.test(password) : true
  const hasSymbol = includeSymbols.value ? /[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(password) : true
  
  return hasUpper && hasLower && hasNumber && hasSymbol
}

// Generate password function
const generatePassword = () => {
  if (!hasValidOptions.value) return
  
  let password = ''
  let attempts = 0
  const maxAttempts = 100
  
  // Keep generating until we get a valid password (like the shell script)
  do {
    password = ''
    for (let i = 0; i < passwordLength.value; i++) {
      const randomIndex = Math.floor(Math.random() * characterSet.value.length)
      password += characterSet.value[randomIndex]
    }
    attempts++
  } while (!isPasswordValid(password) && attempts < maxAttempts)
  
  generatedPassword.value = password
  copied.value = false
  pushHistory(password)
}

// Copy to clipboard function
const copyToClipboard = async () => {
  if (!generatedPassword.value) return
  
  try {
    await navigator.clipboard.writeText(generatedPassword.value)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  } catch (err) {
    console.error('Failed to copy password:', err)
    // Fallback for older browsers
    const textArea = document.createElement('textarea')
    textArea.value = generatedPassword.value
    document.body.appendChild(textArea)
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  }
}

// Generate initial password
generatePassword()

// Watch for changes in options and regenerate if needed
// Removed auto-regeneration on option change to keep history stable

// Keyboard shortcuts
const keyHandler = (e:KeyboardEvent) => {
  if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return
  if (e.key==='r' || e.key==='R') { generatePassword(); e.preventDefault() }
  if (e.key==='c' || e.key==='C') { copyToClipboard(); e.preventDefault() }
  if (e.key==='h' || e.key==='H') { historyOpen.value = !historyOpen.value; e.preventDefault() }
}
onMounted(() => {
  window.addEventListener('keydown', keyHandler)
  // ensure accent defaults (yellow) stays set if variables exist
  document.documentElement.style.setProperty('--accent', '#eab308')
  document.documentElement.style.setProperty('--accent-rgb', '234 179 8')
})
onBeforeUnmount(()=> window.removeEventListener('keydown', keyHandler))

// Segmented strength bar helper
const segmentFillClass = (n:number) => {
  const pct = strengthPercentage.value
  const segments = [25,50,75,100]
  const active = pct >= segments[n-1]
  if (!active) return ''
  if (pct <= 25) return 'bg-red-500'
  if (pct <= 50) return 'bg-yellow-500'
  if (pct <= 75) return 'bg-blue-500'
  return 'bg-green-500'
}
</script>