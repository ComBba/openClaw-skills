---
name: ruby-4-0
description: "Ruby 4.0.1+ 완전 가이드. Ruby Box (정의 격리), ZJIT (차세대 JIT), Ractor 2.0 병렬 처리, 새 Core 클래스 등 모든 신기능 포함."
metadata: {"openclaw":{"emoji":"💎","requires":{"bins":["ruby"]}}}
---

# Ruby 4.0.1+ 완전 가이드 🆕

**릴리즈:** 2025-12-25 (4.0.0) → 2026-01-13 (4.0.1)

Ruby 4.0은 Ruby 역사상 가장 혁신적인 릴리즈 중 하나입니다. 병렬 처리, JIT 컴파일, 정의 격리 등 현대적인 언어 기능을 대거 도입했습니다.

---

## 🎁 Ruby Box (정의 격리) - 실험적

가장 혁신적인 기능! 정의를 격리하여 몽키패칭, 클래스 정의, 전역 변수가 다른 Box에 영향을 주지 않습니다.

### 활성화
```bash
RUBY_BOX=1 ruby myapp.rb
```

### 사용 사례

#### 1. 테스트 격리
```ruby
# 각 테스트가 독립적인 Box에서 실행
# 한 테스트의 monkey patch가 다른 테스트에 영향 없음!

RSpec.configure do |config|
  config.around(:each) do |example|
    Ruby::Box.new { example.run }
  end
end
```

#### 2. Blue-Green 배포
```ruby
# 하나의 Ruby 프로세스에서 두 버전의 앱 동시 실행
old_app = Ruby::Box.new { require 'app_v1' }
new_app = Ruby::Box.new { require 'app_v2' }

# 트래픽 점진적 이전 가능
```

#### 3. 의존성 A/B 테스트
```ruby
# gem 업데이트 전 응답 비교
box_a = Ruby::Box.new { require 'nokogiri-1.15' }
box_b = Ruby::Box.new { require 'nokogiri-1.16' }

# 동일 입력으로 출력 diff 체크
```

**참고:** [Feature #21311](https://bugs.ruby-lang.org/issues/21311)

---

## ⚡ JIT 컴파일러 선택

### YJIT (권장 - 프로덕션)
```bash
ruby --yjit myapp.rb

# Rails에서
RUBY_YJIT_ENABLE=1 rails server
```
- 20-40% 성능 향상
- 안정적, 프로덕션 준비 완료

### ZJIT (실험적 - Ruby 4.0 신규)
```bash
# Rust 1.85+ 필요!
ruby --zjit myapp.rb
```
- YJIT의 차세대 버전
- 더 큰 컴파일 단위 + SSA IR
- **현재는 YJIT보다 느림** (Ruby 4.1에서 개선 예정)
- 기여 환영 (외부 개발자 참여 목적)

### 성능 비교 (벤치마크)
```
Interpreter   ████████████████████ 1.0x
YJIT          ████████████████████████████ 1.4x
ZJIT          ████████████████████████ 1.2x (현재)
```

---

## 🔀 Ractor 2.0 (진정한 병렬 처리)

Ruby 4.0에서 Ractor가 크게 개선되었습니다. Ruby 4.1에서 "실험적" 딱지 제거 예정!

### 새 기능: Ractor::Port
```ruby
# 메시지 송수신 개선
port1 = Ractor::Port.new
port2 = Ractor::Port.new

Ractor.new(port1, port2) do |p1, p2|
  p1.send(1)        # 또는 p1 << 1
  data = p2.receive # 데이터 수신
end
```

### 새 기능: join & value (Thread와 유사)
```ruby
r = Ractor.new { expensive_computation }
r.join              # 완료 대기
result = r.value    # 결과 가져오기
```

### 새 기능: shareable_proc
```ruby
# Ractor 간 Proc 공유 쉬워짐
shared = Ractor.shareable_proc { |x| x * 2 }

Ractor.new(shared) do |proc|
  proc.call(21)  # => 42
end
```

### CPU-intensive 작업 패턴
```ruby
# 병렬 이미지 처리 예시
images = Dir.glob("*.jpg")

results = images.map do |path|
  Ractor.new(path) do |p|
    process_image(p)  # 각 CPU 코어에서 병렬 실행
  end
end

processed = results.map(&:value)
```

### 제약사항 (주의!)
```ruby
# ❌ 가변 객체 공유 불가
shared_array = [1, 2, 3]
Ractor.new { shared_array.push(4) }  # IsolationError!

# ✅ 불변 객체 또는 deep copy 사용
Ractor.new(shared_array.dup) { |arr| arr.push(4) }

# ✅ Ractor.make_shareable 사용
frozen_data = Ractor.make_shareable([1, 2, 3].freeze)
```

---

## 🗣️ 언어 변경

### *nil 동작 변경
```ruby
def foo(*args)
  args
end

# Ruby 3.x: nil.to_a 호출 → []
# Ruby 4.0: nil.to_a 호출 안 함 → []
foo(*nil)  # => []
```

### 논리 연산자 줄바꿈 개선
```ruby
# ✅ Ruby 4.0에서 유효!
if condition1
   && condition2
   && condition3
  do_something
end

# 이전에는 syntax error였음
```

---

## 📦 Core 클래스 업데이트

### Array#rfind (신규!)
```ruby
# reverse_each.find 대체
[1, 2, 3, 4, 5].rfind { |x| x.even? }
# => 4 (마지막 짝수)

# 성능: 끝에서 시작하므로 효율적
large_array.rfind { |x| x > threshold }
```

### Set - 코어 클래스 승격!
```ruby
# require 'set' 불필요!
my_set = Set[1, 2, 3]
my_set.inspect  # => "Set[1, 2, 3]"

# 바로 사용 가능
users = Set.new
users << user1
users << user2
```

### Pathname - 코어 클래스 승격!
```ruby
# require 'pathname' 불필요!
path = Pathname.new("/tmp/myfile.txt")
path.dirname   # => #<Pathname:/tmp>
path.extname   # => ".txt"
```

### Kernel#inspect 커스터마이징
```ruby
class Config
  def initialize(host, password)
    @host = host
    @password = password
  end
  
  # 민감 정보 숨기기
  protected def instance_variables_to_inspect
    [:@host]  # @password 제외
  end
end

Config.new("localhost", "secret123").inspect
# => #<Config @host="localhost">
# 패스워드 노출 안 됨! 🔒
```

### Binding 개선
```ruby
# 숫자 파라미터 접근
binding.implicit_parameters
binding.implicit_parameter_get(:_1)
```

---

## 🚀 성능 최적화 팁

### 1. 메모리 관리 (Variable-Width Allocation)
```ruby
# Ruby 4.0은 가변 폭 할당으로 메모리 단편화 감소
# 특별한 설정 불필요, 자동 적용
```

### 2. YJIT 튜닝
```bash
# 메모리 제한 설정 (기본 256MB)
ruby --yjit --yjit-exec-mem-size=512 myapp.rb

# 통계 출력 (디버깅용)
ruby --yjit --yjit-stats myapp.rb
```

### 3. GC 튜닝
```ruby
# 대용량 앱에서 GC 조정
GC.auto_compact = true  # 자동 메모리 압축
```

---

## 📋 마이그레이션 체크리스트

### Ruby 3.x → 4.0

1. **Rust 확인** (ZJIT 사용 시)
   ```bash
   rustc --version  # 1.85+ 필요
   ```

2. **Gem 호환성 확인**
   ```bash
   bundle update
   bundle exec rubocop  # 경고 확인
   ```

3. **Thread-unsafe gem 제거**
   - Ractor와 충돌 가능
   - 대안 gem 검색 필요

4. **테스트 실행**
   ```bash
   RUBY_BOX=1 rspec  # Box 모드로 테스트
   ```

5. **성능 벤치마크**
   ```bash
   ruby --yjit benchmark.rb
   ```

---

## 🔗 참고 자료

- [Ruby 4.0.0 Release Notes](https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released/)
- [ZJIT Launch Blog](https://railsatscale.com/2025-12-24-launch-zjit/)
- [Ruby Box Feature](https://bugs.ruby-lang.org/issues/21311)
- [Ractor Documentation](https://ruby-doc.org/core/Ractor.html)
