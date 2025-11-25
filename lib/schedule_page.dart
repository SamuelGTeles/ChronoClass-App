import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Horário das Aulas'),
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horário das Aulas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Legenda de abreviações
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Legenda:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem('GP', 'Gerência de Projetos'),
                          _buildLegendItem('SdRC', 'Segurança de Redes de Computadores'),
                          _buildLegendItem('GSII', 'Gestão de Startups II'),
                          _buildLegendItem('CE', 'Cabeamento Estruturado'),
                          _buildLegendItem('HE', 'Horário de Estudo'),
                          _buildLegendItem('PV', 'Projeto de Vida'),
                          _buildLegendItem('MT', 'Mundo do Trabalho'),
                          _buildLegendItem('FC', 'Formação Cidadã'),
                          _buildLegendItem('(A)', 'Aula de Aprofundamento'),
                          _buildLegendItem('AdS', 'Administração de Servidores'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabela de horários
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 8,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 80,
                  columns: const [
                    DataColumn(label: Text('Período', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Segunda', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Terça', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Quarta', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Quinta', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Sexta', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: _scheduleData.map((row) => DataRow(
                    cells: [
                      DataCell(Container(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          row['period']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      DataCell(_buildSubjectCell(row['segunda']!)),
                      DataCell(_buildSubjectCell(row['terca']!)),
                      DataCell(_buildSubjectCell(row['quarta']!)),
                      DataCell(_buildSubjectCell(row['quinta']!)),
                      DataCell(_buildSubjectCell(row['sexta']!)),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String abbreviation, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            abbreviation,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text('= $meaning'),
        ],
      ),
    );
  }

  Widget _buildSubjectCell(String subject) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Text(
        subject,
        style: const TextStyle(fontSize: 12),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static const List<Map<String, String>> _scheduleData = [
    {
      'period': '1',
      'segunda': 'Matemática',
      'terca': 'Sociologia',
      'quarta': 'Técnico (GP)',
      'quinta': 'HE (Rebeca)',
      'sexta': 'Arte',
    },
    {
      'period': '2',
      'segunda': 'Matemática',
      'terca': 'Biologia',
      'quarta': 'Técnico (GP)',
      'quinta': 'Inglês',
      'sexta': 'Geografia',
    },
    {
      'period': 'Intervalo',
      'segunda': 'Carimba/Basq.',
      'terca': 'Vôlei/Altinha',
      'quarta': 'Futsal Feminino',
      'quinta': 'Futsal Masculino',
      'sexta': 'Vôlei/Altinha',
    },
    {
      'period': '3',
      'segunda': 'Projeto (Luan)',
      'terca': 'Técnico (GP)',
      'quarta': 'Técnico (SdRC)',
      'quinta': 'Técnico (GSII)',
      'sexta': 'Técnico (CE)',
    },
    {
      'period': '4',
      'segunda': 'Português',
      'terca': 'Matemática',
      'quarta': 'Técnico (SdRC)',
      'quinta': 'Técnico (GSII)',
      'sexta': 'Técnico (CE)',
    },
    {
      'period': '5',
      'segunda': 'Português',
      'terca': 'História',
      'quarta': 'Espanhol',
      'quinta': 'Português (A)',
      'sexta': 'Técnico (CE)',
    },
    {
      'period': 'Almoço',
      'segunda': '',
      'terca': '',
      'quarta': '',
      'quinta': '',
      'sexta': '',
    },
    {
      'period': '6',
      'segunda': 'Alemão',
      'terca': 'FC',
      'quarta': 'Técnico (AdS)',
      'quinta': 'Biologia',
      'sexta': 'PV',
    },
    {
      'period': '7',
      'segunda': 'Alemão',
      'terca': 'Projeto (Luan)',
      'quarta': 'Técnico (AdS)',
      'quinta': 'Ed Física',
      'sexta': 'MT',
    },
    {
      'period': 'Intervalo',
      'segunda': 'Futsal Masculino',
      'terca': 'Carimba/Basq.',
      'quarta': 'Vôlei/Altinha',
      'quinta': 'Carimba/Basq.',
      'sexta': 'Futsal Masculino',
    },
    {
      'period': '8',
      'segunda': 'Química',
      'terca': 'Técnico (AdS)',
      'quarta': 'Geografia',
      'quinta': 'Redação',
      'sexta': 'Física',
    },
    {
      'period': '9',
      'segunda': 'Química',
      'terca': 'Técnico (AdS)',
      'quarta': 'Física (A)',
      'quinta': 'Filosofia',
      'sexta': 'História (A)',
    },
  ];
}