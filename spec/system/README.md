# Test Guide

ยินดีต้อนรับสู่ Test Code ของโปรเจกต์นี้!  
เอกสารนี้จะช่วยให้คุณเข้าใจโครงสร้าง และอ่าน/เขียน/เข้าใจเทสได้อย่างรวดเร็ว

---

## 1. โครงสร้าง Test

- ใช้ RSpec + Capybara สำหรับ System Test
- ทุกไฟล์จะลงท้าย `*_spec.rb`

```ruby
RSpec.feature "Feature Name", type: :system, js: true do
  describe "Behavior" do
    # ข้อมูลเริ่มต้น
    given!(:something) { create(:model) }

    context "เงื่อนไข" do
      background do
        # สิ่งที่ต้องทำก่อนเทส เช่น login, visit หน้า
      end

      scenario "กรณีการทดสอบ" do
        # การกระทำ (Action) + ผลลัพธ์ที่คาดหวัง (Assertion)
      end
    end
  end
end
```

---

## 2. คำสั่งสำคัญที่ใช้บ่อย

| Syntax                                         | ความหมาย                                     | ตัวอย่าง                 |
| :--------------------------------------------- | :------------------------------------------- | :----------------------- |
| `given!(:user) { create(:user) }`              | สร้างข้อมูลใน database ก่อนเริ่มเทส          | สร้าง user ขึ้นมาคนหนึ่ง |
| `background do ... end`                        | สิ่งที่ต้องทำก่อนทุก scenario ใน context นี้ | login, visit หน้า        |
| `scenario "..." do ... end`                    | เคสทดสอบแต่ละอัน                             | ทดสอบว่าคอมเมนต์สำเร็จ   |
| `fill_in 'field-data-testid', with: 'ข้อความ'` | พิมพ์ข้อความลงใน input                       | พิมพ์ "hello" ลง comment |
| `click_on 'button-data-testid'`                | คลิกปุ่มหรือ element ที่ระบุ                 | คลิกปุ่ม submit          |
| `expect(page).to have_content('ข้อความ')`      | ตรวจว่ามีข้อความในหน้าเว็บ                   | เห็น "Comment created"   |
| `expect(page).not_to have('selector')`         | ตรวจว่าไม่มี element นั้น                    | ปุ่ม edit ไม่ปรากฏ       |
| `visit path`                                   | เข้าไปยังหน้าเว็บตาม path                    | visit หน้า Board         |

---

## 3. การตั้งชื่อ data-testid

- มักจะใช้รูปแบบ **entity-id-action-button**  
  เช่น:
  - `submit-comment-button`
  - `edit-comment-123-button`
  - `delete-comment-456-button`
  - `board-789-upvote-button`
  - `comment-101-upvote-button`

**Tip**: เวลาเห็นชื่อ id ก็จะรู้ทันทีว่าเป็นปุ่มทำ action อะไรกับ entity ไหน (board/comment)

---

## 4. แนวทางการเขียน Test Case

- แต่ละ scenario จะเน้น **1 กรณีการใช้งานจริง**
- Flow จะเป็น
  1. เตรียมข้อมูล (`given!`)
  2. เข้าเว็บ (`visit`)
  3. ทำ Action (`fill_in`, `click_on`)
  4. เช็คผลลัพธ์ (`expect(page)...`)

---

## 5. ตัวอย่าง flow เต็มๆ

> ตัวอย่างทดสอบการโพสต์คอมเมนต์

```ruby
scenario "posts a comment on a board" do
  fill_in 'comment-input', with: 'Great board!'
  click_on 'submit-comment-button'
  expect(page).to have_content('Great board!')
  expect(page).to have_content('Comment was successfully created.')
end
```

- พิมพ์ 'Great board!' ลงไป
- คลิก submit
- เช็คว่ามีข้อความที่โพสต์ขึ้น และระบบแจ้งว่าบันทึกคอมเมนต์สำเร็จ

---

## 6. หมายเหตุ

- เทสใช้ Database Cleaner หรือ transaction isolation ดังนั้นข้อมูลที่สร้าง (`given!`) จะรีเซ็ตทุกเทส
- เน้นความเร็ว อ่านง่าย ทำงานได้จริงใน browser จริง (JS เปิดอยู่ เพราะ `js: true`)

---

# จบสรุป!

> อ่านแค่ไฟล์นี้ แล้วไปอ่านโค้ดเทส → เข้าใจหมดแน่นอน 💥
