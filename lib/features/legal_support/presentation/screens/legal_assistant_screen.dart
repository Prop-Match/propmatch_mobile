import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';

class LegalAssistantScreen extends StatefulWidget {
  const LegalAssistantScreen({super.key});

  @override
  State<LegalAssistantScreen> createState() => _LegalAssistantScreenState();
}

class _LegalAssistantScreenState extends State<LegalAssistantScreen> {
  final _textController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text': 'أهلاً بك! أنا المساعد القانوني الذكي لمنصة PropMatch AI. استفساراتي مستندة إلى تشريعات وقانون الإيجار المصري (القانون رقم 4 لسنة 1996 وتعديلاته). كيف يمكنني مساعدتك اليوم؟',
    }
  ];
  bool _isGenerating = false;

  void _ask(String prompt) {
    if (prompt.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': prompt});
      _isGenerating = true;
      _textController.clear();
    });

    // Simulate AI response with citations
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _messages.add({
            'role': 'assistant',
            'text': 'وفقاً للمادة (1) و(2) من القانون رقم 4 لسنة 1996 بشأن سريان أحكام القانون المدني على عقود الإيجار الجديدة:\n\n1. تخضع عقود الإيجار المبرمة بعد عام 1996 لإرادة المتعاقدين في تحديد المدة والأجرة وطريقة الزيادة السنوية.\n2. يلزم إثبات تاريخ العقد بالشهر العقاري أو توثيقه لحفظ حقوق الطرفين في النفاذ والتنفيذ.\n3. الصيانة الأساسية تقع على عاتق المؤجر ما لم يتفق الطرفان كتابياً على خلاف ذلك.\n\n⚠️ تنبيه: هذه الإجابة استرشادية مبنية على النصوص القانونية ولا تغني عن استشارة محامٍ متخصص.',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد القانوني الذكي'),
      ),
      body: Column(
        children: [
          // Disclaimer Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.info.withValues(alpha: 0.08),
            child: const Row(
              children: [
                Icon(LucideIcons.scale, color: AppColors.info, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'استشارات مدعومة بقانون الإيجارات المصري والمصادر الرسمية',
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppConstants.paddingMd),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAssistant = msg['role'] == 'assistant';

                return Align(
                  alignment: isAssistant ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                    decoration: BoxDecoration(
                      color: isAssistant ? Colors.white : AppColors.primary,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: isAssistant ? Border.all(color: AppColors.border) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isAssistant)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.sparkles, size: 14, color: AppColors.accent),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'PropMatch Legal AI',
                                style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        if (isAssistant) const SizedBox(height: 6),
                        Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isAssistant ? AppColors.textPrimary : Colors.white,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isGenerating)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'جاري استرجاع المواد القانونية وصياغة الإجابة...',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'اسأل عن حقوق المستأجر، المؤجر، بنود العقد...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      onSubmitted: _ask,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _ask(_textController.text),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
